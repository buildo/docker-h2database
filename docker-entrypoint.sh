#!/usr/bin/env bash
set -e

SERVER="java -cp /h2/bin/h2.jar org.h2.tools.Server"
RUNSCRIPT="java -cp /h2/bin/h2.jar org.h2.tools.RunScript"

runSql() {
  filename=$(basename "$1")
  db="${filename%.*}"
  url="jdbc:h2:$H2DATA/$db"
  echo "using url $url"
  $RUNSCRIPT -script "$1" -url "$url"
}

mkdir -p "$H2DATA"

if [ ! -f "$H2DATA/.initdb.completed" ]; then

  echo
  for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
      *.sh)     echo "$0: running $f"; . "$f" ;;
      *.sql)    echo "$0: running $f"; runSql "$f" ;;
      *)        echo "$0: ignoring $f" ;;
    esac
    echo
  done
  touch "$H2DATA/.initdb.completed"

fi

exec "$@"
