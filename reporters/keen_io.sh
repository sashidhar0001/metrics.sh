#!/bin/sh

defaults () {
  if [ -z $KEEN_IO_EVENT_COLLECTION ]; then
    KEEN_IO_EVENT_COLLECTION=$(hostname)
  fi
}

start() {
  if [ -z $KEEN_IO_PROJECT_ID ]; then
    echo "Error: keen_io requires \$KEEN_IO_PROJECT_ID to be specified"
    return 1
  fi

  if [ -z $KEEN_IO_WRITE_KEY ]; then
    echo "Error: keen_io requires \$KEEN_IO_WRITE_KEY to be specified"
    return 1
  fi

  __keen_io_api_url="https://api.keen.io/3.0"
  __keen_io_api_url="$__keen_io_api_url/projects/$KEEN_IO_PROJECT_ID"
  __keen_io_api_url="$__keen_io_api_url/events/$KEEN_IO_EVENT_COLLECTION"
  __keen_io_api_url="$__keen_io_api_url?api_key=$KEEN_IO_WRITE_KEY"
}

report () {
  local metric=$1
  local value=$2

  curl -s $__keen_io_api_url -H "Content-Type: application/json" \
       -d "{\"metric\":\"$metric\",\"value\":$value}"
}

docs () {
  echo "Send data to Keen IO (https://keen.io)."
  echo "KEEN_IO_WRITE_KEY=$KEEN_IO_WRITE_KEY"
  echo "KEEN_IO_PROJECT_ID=$KEEN_IO_PROJECT_ID"
  echo "KEEN_IO_EVENT_COLLECTION=$KEEN_IO_EVENT_COLLECTION"
}