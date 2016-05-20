#!/bin/sh
{
  git log --pretty=tformat:%ct HEAD~2.. |
  tail -n 2
  echo 0
} |
{
  read NEW
  read OLD
  if [ $NEW -le $OLD ]; then
   GIT_COMMITTER_DATE=@`expr $OLD + 1` \
    git commit --amend --reuse-message HEAD
  fi
}
