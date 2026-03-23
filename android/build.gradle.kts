allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // 1. Configuramos el directorio de build para cada subproyecto
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // 2. Corrección de Namespace para plugins antiguos (como tflite_flutter 0.10.1)
    afterEvaluate {
        if (hasProperty("android")) {
            val android = extensions.getByName("android")
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                if (getNamespace.invoke(android) == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, group.toString())
                }
            } catch (e: Exception) {
                // Se ignora si no es compatible o ya tiene namespace
            }
        }
    }
}

// 3. Dependencia de evaluación (solo para plugins, no para el app mismo)
subprojects {
    if (project.name != "app") {
        evaluationDependsOn(":app")
    }
}

// 4. Tarea de limpieza
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}