## Django Applications

For Django applications that run using their own executable, you must configure the following environment variables in your deployment setup:

### Required Environment Variables

- **PYTHONPATH**  
  Path to the root directory of your Django application.  
  Example:
  ```bash
  PYTHONPATH=/app
  ```

- **DJANGO_SETTINGS_MODULE**  
  Name of the Django settings module.
  Example:
  ```bash
  DJANGO_SETTINGS_MODULE=myapp.settings
  ```

## Excluded URLs
Comma-separated regular expressions representing which URLs to exclude across all instrumentations:

- **OTEL_PYTHON_EXCLUDED_URLS**

You can also exclude URLs for specific instrumentations by using a variable OTEL_PYTHON_`<library>`_EXCLUDED_URLS, where library is the uppercase version of one of the following: Django, Falcon, FastAPI, Flask, Pyramid, Requests, Starlette, Tornado, urllib, urllib3.
Example:
```bash
export OTEL_PYTHON_EXCLUDED_URLS="client/.*/info,healthcheck"
export OTEL_PYTHON_URLLIB3_EXCLUDED_URLS="client/.*/info"
export OTEL_PYTHON_REQUESTS_EXCLUDED_URLS="healthcheck"
```