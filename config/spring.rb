# Ensure env variables are current
if defined? Spring
  Spring.watch 'config/application.yml'
end