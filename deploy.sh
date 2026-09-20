#!/bin/bash
# ---------------------------------------------------------------
# SLCA Course - Deploy to Apache server
# Usage: ./deploy.sh
# First run: set SERVER_USER and SERVER_HOST below
# ---------------------------------------------------------------

SERVER_USER="your-user"
SERVER_HOST="your-server-ip"
REMOTE_PATH="/var/www/html"
LOCAL_PATH="$(cd "$(dirname "$0")" && pwd)"

echo "SLCA Course Deploy"
echo "From: $LOCAL_PATH"
echo "To:   $SERVER_USER@$SERVER_HOST:$REMOTE_PATH"
echo ""

# Check rsync is available
if ! command -v rsync &> /dev/null; then
  echo "ERROR: rsync is not installed. Install with: brew install rsync"
  exit 1
fi

# Sync files - exclude build/ directory and this deploy script's backup files
rsync -avz --progress \
  --exclude='build/' \
  --exclude='.DS_Store' \
  --exclude='*.swp' \
  --exclude='deploy.sh.bak' \
  "$LOCAL_PATH/" \
  "$SERVER_USER@$SERVER_HOST:$REMOTE_PATH/"

if [ $? -eq 0 ]; then
  echo ""
  echo "Deploy complete."
  echo "Course is live at: http://$SERVER_HOST/"
  echo ""
  echo "To update in the future, run this script again after saving your changes."
else
  echo ""
  echo "ERROR: Deploy failed. Check your server connection and try again."
  exit 1
fi
