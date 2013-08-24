﻿using System;
using System.IO;
using System.Web;
using System.Web.Http;
using System.Web.Http.OData;
using System.Web.Http.OData.Query;
using System.Linq;
using YangKai.BlogEngine.Domain;
using YangKai.BlogEngine.Service;

namespace YangKai.BlogEngine.Web.Mvc.Controllers
{
    public class ArticleController : EntityController<Post>
    {
        [Queryable(AllowedQueryOptions = AllowedQueryOptions.All, PageSize = 10, MaxExpansionDepth = 5)]
        public override IQueryable<Post> Get()
        {
            return Proxy.Repository<Post>().GetAll();
        }

        protected override Post CreateEntity(Post entity)
        {
            return AddArticle(entity);
        }

        protected override Post UpdateEntity(Guid key, Post update)
        {
            var entity = Proxy.Repository<Post>().Get(key);
            entity.Categorys.Clear();
            Proxy.Repository<Tag>().Remove(entity.Tags);
            Proxy.Repository<Source>().Remove(entity.Source);
            Proxy.Repository<Thumbnail>().Remove(entity.Thumbnail);
            Proxy.Repository<QrCode>().Remove(entity.QrCode);
            Proxy.Repository<Post>().Remove(entity);

            return AddArticle(update,false);
        }

        private Post AddArticle(Post entity,bool isNew = true)
        {
            entity.Title = entity.Title.Trim();
            entity.Url = entity.Url.Trim().ToLower().Replace(" ", "-");

            entity.Group = Proxy.Repository<Group>().Get(entity.Group.GroupId);

            for (int i = 0; i < entity.Categorys.Count; i++)
            {
                entity.Categorys[i] = Proxy.Repository<Category>().Get(entity.Categorys[i].CategoryId);
            }

            if (isNew)
            {
                entity.PubAdmin = Proxy.Repository<User>().Get(p => p.UserName == Current.User.UserName);
                entity.PubDate = DateTime.Now;
            }
            else
            {
                entity.EditAdmin = Proxy.Repository<User>().Get(p => p.UserName == Current.User.UserName);
                entity.EditDate = DateTime.Now;
            }

            if (entity.Thumbnail != null)
            {
                var filename = entity.PubDate.ToString("yyyy.MM.dd.") + entity.Url + Path.GetExtension(entity.Thumbnail.Url);
                var source = string.Format("{0}/{1}", HttpContext.Current.Server.MapPath("~/upload/temp"), entity.Thumbnail.Url);
                var target = string.Format("{0}/{1}", HttpContext.Current.Server.MapPath("~/upload/thumbnail"), filename);
                if (File.Exists(source))
                {
                    if (File.Exists(target))
                    {
                        File.Delete(target);
                    }
                    File.Move(source, target);
                    entity.Thumbnail.Url = filename;
                }
            }

            return Proxy.Repository<Post>().Add(entity);
        }

        [HttpPost]
        public void Browsed([FromODataUri] Guid key, ODataActionParameters parameters)
        {
            var entity = Proxy.Repository<Post>().Get(key);
            entity.ViewCount++;
            Proxy.Repository<Post>().Update(entity);
        }

        [HttpPost]
        public void Commented([FromODataUri] Guid key, ODataActionParameters parameters)
        {
            var entity = Proxy.Repository<Post>().Get(key);
            entity.ReplyCount = entity.Comments.Count(p=>!p.IsDeleted);
            Proxy.Repository<Post>().Update(entity);
        }
    }
}