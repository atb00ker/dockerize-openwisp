from django.conf.urls import include, url
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from openwisp_utils.admin_theme.admin import admin, openwisp_admin
from django.urls import reverse_lazy
from django.views.generic import RedirectView

redirect_view = RedirectView.as_view(url=reverse_lazy('admin:index'))
openwisp_admin()

urlpatterns = [
    url(r'^', include('openwisp_network_topology.urls')),
    url(r'^admin/', admin.site.urls),
    url(r'^$', redirect_view, name='index')
]

urlpatterns += staticfiles_urlpatterns()
