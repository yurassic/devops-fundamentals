#!/bin/bash

if [[ ! -f "data/users.db" ]]; then
  read -p "The users.db file does not exist. Create it? [y/n]: " answer
  if [[ "$answer" =~ ^[yY]$ ]]; then
    touch data/users.db
  else
    echo "Exiting."
    exit 1
  fi
fi

# Add user
function add_user {
  read -p "Enter username (Latin letters only): " username
  if ! [[ "$username" =~ ^[a-zA-Z]+$ ]]; then
    echo "Error: Invalid username, please use only Latin letters."
    return 1
  fi

  read -p "Enter role (Latin letters only): " role
  if ! [[ "$role" =~ ^[a-zA-Z]+$ ]]; then
    echo "Error: Invalid role, please use only Latin letters."
    return 1
  fi

  echo "$username,$role" >> data/users.db
  echo "User added: $username,$role"
}

if [[ "$1" == "add" ]]; then
  add_user
fi

# Help
function show_help {
  echo "Usage: db.sh [command]"
  echo ""
  echo "Available commands:"
  echo "  add      - Add a new user to the users database"
  echo "  backup   - Create a backup of the users database"
  echo "  find     - Find users by username or role"
  echo "  list     - List all users in the database"
  echo "  help     - Show this help message"
  echo ""
}

if [[ "$1" == "help" ]]; then
  show_help
  exit 0
fi

# Backup
function backup {
  local date=$(date +"%Y-%m-%d")
  local backup_file="${date}-users.db.backup"
  cp data/users.db "$backup_file"
  echo "Created backup file: $backup_file"
}

if [[ "$1" == "backup" ]]; then
  backup
  exit 0
fi


# Restore
function restore {
  backup_file="$(ls -t *-users.db.backup | head -n 1)"
  if [[ -z "$backup_file" ]]; then
    echo "No backup file found."
    return 1
  fi

  cp "$backup_file" data/users.db
  echo "Database restored from backup file: $backup_file"
}

if [[ "$1" == "restore" ]]; then
  restore
  exit 0
fi

# Find
function find {
  read -p "Enter username to search for: " search_username
  matching_users=$(grep -i "^$search_username," data/users.db)
  if [[ -z "$matching_users" ]]; then
    echo "User not found."
  else
    echo "Matching users:"
    echo "$matching_users"
  fi
}

if [[ "$1" == "find" ]]; then
  find
  exit 0
fi


# List
function list {
  if [[ "$1" == "--inverse" ]]; then
    tac data/users.db | nl -ba
  else
    nl data/users.db
  fi
}

if [[ "$1" == "list" ]]; then
  list
  exit 0
fi