allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Define build directory relative to project root
val flutterBuildDir = file("${rootProject.projectDir}/../build")
rootProject.buildDir = flutterBuildDir

subprojects {
    project.buildDir = file("${flutterBuildDir}/${project.name}")
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(flutterBuildDir)
}
