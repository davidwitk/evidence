## Description & motivation
<!---
Describe your changes, and why you're making them. Is this linked to an open
Jira ticket or another pull request? Link it here.

Include a screenshot of the relevant section of the updated DAG. If it's a dbt 
DAG, you can access your version of the DAG by running `dbt docs generate && 
dbt docs serve`.
-->

## Validation of models (QA)
<!---
Include any output that confirms that the models do what is expected. This might
be a link to an in-development dashboard in your BI tool, or a query that
compares an existing model with a new one.
-->

## To-do before merge
<!---
(Optional -- remove this section if not needed)
Include any notes about things that need to happen before this PR is merged, e.g.:
- [ ] Change the base branch
- [ ] Update dbt Cloud jobs
- [ ] Ensure PR #56 is merged
-->

## To-do after merge
<!---
(Optional -- remove this section if not needed)
Include any notes about things that need to happen after this PR is merged, e.g.:
- [ ] Old models should be dropped after merge
- [ ] Full-refresh run is required in case an incremental model is changed
-->

## Checklist
<!---
This checklist is mostly useful as a reminder of small things that can easily be
forgotten – it is meant as a helpful tool rather than hoops to jump through.
Put an `x` in all the items that apply, make notes next to any that haven't been
addressed, and remove any items that are not relevant to this PR.
-->

- [ ] My pull request represents one logical piece of work.
- [ ] My commits are related to the pull request and look clean.
- [ ] My SQL follows the style guide. I have linted it with SQLFluff.
- [ ] I have run all related models and tests in my development environment.
- [ ] I have added appropriate tests and documentation to any new models.
- [ ] I have checked the impact on external dependecies such as exposures. 
