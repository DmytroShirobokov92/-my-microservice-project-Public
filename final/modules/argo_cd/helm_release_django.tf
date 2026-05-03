# final/modules/argo_cd/helm_release_django.tf

resource "helm_release" "django" {
  name       = "django-app"
  chart      = "${path.root}/charts/django-app"
  namespace  = "default"

   values = [file("${path.root}/charts/django-app/values.yaml")]

  set = [
    {
      name  = "image.repository"
      value = var.django_image_repository
    },
    {
      name  = "config.POSTGRES_HOST"
      value = var.db_host
    },
    {
      name  = "config.POSTGRES_DB"
      value = var.db_name
    },
    {
      name  = "config.POSTGRES_USER"
      value = var.db_user
    }
  ]

   set_sensitive = [
    {
       name  = "config.POSTGRES_PASSWORD"
       value = var.db_password
     }
   ]
}
