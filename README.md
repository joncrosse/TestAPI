### Mock API for a social media website. The API can create users, suggest friends, post stories, follow and unfollow users, block user, show user profiles, and generate a timeline of posts


----------------------------------------------------------------------
Project Write Up
Name          - Jack Hancock
Team name     - BOC
Team size     - 2 
Team url      -  http://jcha265.cs.uky.edu:9990
Jack Hancock  - 50%
Jon Crosse    - 50%

----------------------------------------------------------------------

Project contribution: Me and my partner Jon Crosse have worked through almost the entire project together through zoom and the work was split very evenly. Overall, I did most of the SQL coding and Jon did most of the Ruby coding. However, we both know how to do each of these and would help eachother out when we got stuck on things. Thus, we both did a little of each side. 

---------------------------------------------------------------------

SOURCES:
https://www.w3schools.com/sql/sql_ref_keywords.asp - This is a huge SQL references web page. It helps to explain how all of the SQL commands work. I referenced this page numerous times throughout the project to make sure I was using commands like EXISTS IN, specific JOINs, and other commands correctly. No code was copied from this page.

https://guides.rubyonrails.org/getting_started.html - Before starting this project, me and Jon both did this official Ruby on Rails introduction project so that we could learn more about RoR before diving in.

https://guides.rubyonrails.org/api_app.html - During the project we referenced this official Ruby on Rails documentation that provided us tips on how to build an API only RoR server

----------------------------------------------------------------------

Table of Endpoints:
1. /api/createuser     // Complete
2. /api/seeuser        // Complete
3. /api/suggestions    // Complete
4. /api/poststory      // Complete
5. /api/reprint        // Complete
6. /api/follow         // Complete
7. /api/unfollow       // Complete
8. /api/block          // Complete
9. /api/timeline       // Complete
----------------------------------------------------------------------

Our team used Ruby on Rails to create a RESTful API server.

How to run our server:

1. Make sure you have Ruby / Ruby On Rails installed on your machine correctly
2. Open terminal and navigate to inside of 'RailServer' directory
3. Run command 'Rails s' to start server
4. You can then open a new terminal to make curl / API calls to the server

----------------------------------------------------------------------
