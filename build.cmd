@echo off
cd /d %~dp0\src
start python -m http.server 80 -new_console
cd /d %~dp0

rem email read_requests read_friendlists 
rem user_groups user_events user_hometown user_interests user_likes user_photos user_relationships user_relationship_details user_subscriptions user_videos
rem friends_groups friends_events friends_hometown friends_interests friends_likes friends_photos friends_relationships friends_relationship_details friends_subscriptions friends_videos 