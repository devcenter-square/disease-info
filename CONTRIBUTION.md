Contributing
============

We have a contributors Slack room, kindly fill this contributors form to get added: https://docs.google.com/forms/d/1JiRNzYS69ojHPCql254HMMmp72cRb2TMGVC6BiOTw6E/viewform?c=0&w=1

**The #1 contribution you could make is to blog, share, post, tweet, and tell people about disease-info.  This will go a long ways towards helping build a sustainable community.**

We are happy to accept contributions of any kind, including feedback and ideas, translations for other locales, and functionality. For new functionality, follow the standard approach by filling the form above.

Git Workflow
============
The array of possible workflows can make it hard to know where to begin when implementing Git in the workplace. This page provides a starting point by surveying the most common Git workflows for enterprise teams. As you read through, remember that these workflows are designed to be guidelines rather than concrete rules.

5. Before you continue with this guideline, It is assumed that you have a basic knowledge of using version control. If not, you might want to take tutorials on that.
4. After cloning the project and going through the README.md to set up the project, make sure to branch from the develop branch into your feature branch. Don't ever branch from the master branch into the feature branch. From the master branch you should only branch hotfixes because the master branch is the stable version of this project.
3. When a feature branch is done, it will be reviewed by a PR Team member. Finally after a complete and thorough review, the PR Team merge your features into the develop branch and from there into the master branch for the next version release.
2. It is recommended for you to learn how to rebase your feature branches on top of the develop branch each time another feature is merged into develop to avoid resolving conflicts on merge time, but in isolation on the feature branch where you know what your changes are.
1. The whole idea with this kind of workflows is to have a stable version branch in which you can work and fix any bug immediately if you need to with enough confidence that it will still be stable and no new feature or refactorization will slip in without noticing.

License
=======

Copyright 2016, devcenter-square. Disease-info is released under the MIT open source license.  Please contribute back any enhancements you make.
