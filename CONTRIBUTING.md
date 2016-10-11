Contributing
============

We have a Contributors' Slack channel inside [DC Square's Slack Channel](https://devcenter-square.slack.com).

Want to join the Contributors' channel?

First Sign up [here](https://devcenter-square-slack.herokuapp.com/) to join the DC Square Slack Channel, then fill this [contributors form](https://docs.google.com/forms/d/1JiRNzYS69ojHPCql254HMMmp72cRb2TMGVC6BiOTw6E/viewform?c=0&w=1) to get added to the the Disease Info Contributors' channel.

**The #1 contribution you could make is to blog, share, post, tweet, and tell people about disease-info.  This will go a long way in building a sustainable community.**

Your next stop should be at the [issues page](https://github.com/devcenter-square/disease-info/issues). Here you can find a list of issues to fix as regards either the ongoing project, or bugs on the app.

From time to time, there would be ongoing [project(s)](https://github.com/devcenter-square/disease-info/projects). Feel free to take a look at the [project's page](https://github.com/devcenter-square/disease-info/projects) to get a clearer idea of what the ongoing projects are and view related issues to get the projects completed.

We are happy to accept contributions of any kind, including feedback and ideas, translations for other locales, and functionality.

If you want to add new functionality, you can follow the standard approach by filling the form above.

Git Workflow
============
The array of possible workflows can make it hard to know where to begin when implementing Git in the workplace. This page provides a starting point by surveying the most common Git workflows for enterprise teams. As you read through, remember that these workflows are designed to be guidelines rather than concrete rules.

5. Before you continue with this guideline, It is assumed that you have a basic knowledge of using version control. If not, you might want to check out these tutorials:
  6. [GitHub Workflow](https://learn.wheelhouse.io/events/workflow) by GitHub and Wheelhouse - A summarized tutorial on using GitHub's version control.
  7. [GitHub for Developers](https://learn.wheelhouse.io/events/early-access) by GitHub and Wheelhouse - A more in-depth tutorial on how to use GitHub. Do note that this in-depth tutorial is an early access preview and can be removed at anytime.
  8. [How to Use Git and GitHub] (https://www.udacity.com/course/how-to-use-git-and-github--ud775) by Udacity - A free beginner level course on the basics of using version control.
4. After cloning the project and going through the [README.md](https://github.com/devcenter-square/disease-info/blob/develop/README.md) to set up the project, make sure to branch from the develop branch into your feature (own) branch. **Don't ever** branch from the master branch into the feature branch. From the master branch you should only branch hotfixes because the master branch is the stable version of this project.
3. When a feature branch is done, it will be reviewed by a PR Team member. Finally after a complete and thorough review of the pull request, the PR Team merges your features into the develop branch and from there into the master branch for the next version release.
2. It is recommended for you to learn how to rebase your feature branches on top of the develop branch each time another feature is merged into develop to avoid resolving conflicts on merge time, but in isolation on the feature branch where you know what your changes are.
1. The whole idea with this kind of workflow is to have a stable version branch in which you can work and fix any bug immediately if you need to with enough confidence that it will still be stable and no new feature or refactorization will slip in without noticing.

License
=======

Copyright 2016, devcenter-square. Disease-info is released under the MIT open source license.  Please contribute back any enhancements you make.
