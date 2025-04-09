# Contributions

We welcome all contributions to this project!
If you notice a bug, or have a feature request, please open up an issue [here](https://github.com/DSCI-310-2025/dsci-310-group-06/issues).
If you'd like to contribute a feature or bug fix, you can fork or clone our repo and submit a pull request. For more in-depth instructions, see below.
We will review pull requests within 7 days.
All contributors must abide by our [code of conduct](CODE_OF_CONDUCT.md).

## How to Contribute

1. Clone the repository from a terminal
```bash
git clone https://github.com/DSCI-310-2025/dsci-310-group-06.git
```

2. Change the working directory to the project folder
```bash
cd dsci-310-group-06
```

3. Create a new branch and switch to it
```bash
git checkout -b <username>-<task_description>-<step_num>
```
> IMPORTANT: Branches must follow the format `<username>-<task_description>-<step_num>` and be derived from either `main` or from an existing branch should you with to edit from there.

> Example of a good branch name: `jane_doe-create-bar-plot-function-m3`

4. Make your changes
    - Remember to regularly pull changes from the origin `main` branch to your local `main` branch.
    - If you're fixing a bug or adding a feature, be sure to:

> Ensure that your changes do not break any existing functionality

> Follow the existing coding style and guidelines of the project.

> If applicable, add tests to ensure the functionality works as expected.

> Update documentation, if necessary (`README.md`, etc.).

    

5. Commit your changes
    - Once your changes are complete, commit them with a descriptive message

6. Push your changes
```bash
git push origin <branch-name>
```

## Pull Requests

1. After pushing your changes, go to the project page on GitHub and create the pull request.
    - Add more information to the extended decription if necessary.
    - Resolve any merge conflicts that pop up with Merge Editor on VSCode; do not recklessly combine both versions of the file together.
    - Warning: `.ipynb` files will not work with Merge Editor on VSCode; please outline them on Google Docs first before committing.
2. Once your pull request is open, the project maintainers will review it. They may suggest changes or improvements. Be open to feedback and be ready to make additional commits if necessary.
3. Once your pull request is reviewed, feel free to merge the commit to main. Thank you for your contribution!

## Reporting Issues and Seeking Support

- For further information on seeking support, please see the [code of conduct](CODE_OF_CONDUCT.md).

1. Go to the "Issues" tab in GitHub.
2. Click "New issue".
3. Provide a reasonably descriptive title and elaborate in the description.
4. If necessary, provide additional sub-issues and corresponding details as concrete steps to complete.
5. Once the issue/sub-issue is completed, remember to close it.

## External Documentation

- [README.md](README.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [MIT License](LICENSE-MIT.md)
- [Creative Commons License](LICENSE-CC.md)
- [Diabetes Classification Report (HTML)](reports/diabetes_classification_report.html)
- [Dataset Download Python Code](src/dataset_download.py)
