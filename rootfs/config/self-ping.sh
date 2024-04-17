#!/bin/bash
if [ -z "$APP_NAME" ]; then
  echo "APP_NAME unset, terminating..."
  exit 0
fi

while true; do
  if curl -f -s "https://$APP_NAME.herokuapp.com" > /dev/null; then
      echo "Ping successful."
  else
      echo "Ping failed, retrying..."
      if curl -f -s "https://$APP_NAME.herokuapp.com" > /dev/null; then
          echo "Ping successful on retry."
      else
          echo "Cannot ping app, terminating..."
          exit 1
      fi
  fi

  if [ "$NO_SLEEP" != "1" ]; then
      sleep 25
  fi
done