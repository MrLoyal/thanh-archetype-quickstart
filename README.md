
### A custom Maven archetype


I used to use ```maven-archetype-quickstart``` to scaffold my simple projects. But it generates code with out dated dependencies.


So this is the alternative with more recent version of libraries.


### How to use

Clone this repository and then install it
```
git clone https://github.com/MrLoyal/thanh-archetype-quickstart.git
cd thanh-archetype-quickstart
mvn clean install
```

Then generate new project
```
mvn archetype:generate \
  -DgroupId=com.your.company \
  -DartifactId=your-project-name \
  -Dversion=1.0 \
  -DarchetypeGroupId=com.thanh \
  -DarchetypeArtifactId=thanh-archetype-quickstart
```

Your project is ready!

*__Happy coding!__*
