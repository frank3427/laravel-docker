[program:laravel-horizon]
process_name=%(program_name)s
command=php artisan horizon
directory=%%REMOTE_SRC%%
autostart=true
autorestart=true
redirect_stderr=true
stderr_logfile=%%REMOTE_SRC%%/storage/logs/horizon.err.log
stdout_logfile=%%REMOTE_SRC%%/storage/logs/horizon.out.log
numprocs=1
startretries=2
user=%%DEFAULT_USER%%
environment=REDIS_HOST="%%REDIS_HOST%%",REDIS_PORT="%%REDIS_PORT%%"
