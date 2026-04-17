import org.gradle.api.tasks.compile.JavaCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Older Flutter plugins (e.g. image_gallery_saver) omit `android.namespace`, which AGP 8+ requires.
// Derive it from `src/main/AndroidManifest.xml` when missing so the app can build without patching pub-cache.
subprojects {
    fun org.gradle.api.Project.applyLegacyLibraryNamespaceFromManifest() {
        if (!plugins.hasPlugin("com.android.library")) {
            return
        }
        val androidExt = extensions.findByName("android") ?: return
        val getNs =
            androidExt.javaClass.methods.firstOrNull { it.name == "getNamespace" && it.parameterCount == 0 }
                ?: return
        val existing = (getNs.invoke(androidExt) as? String)?.trim().orEmpty()
        if (existing.isNotEmpty()) {
            return
        }
        val manifest = file("src/main/AndroidManifest.xml")
        if (!manifest.exists()) {
            return
        }
        val pkg =
            Regex("""package\s*=\s*["']([^"']+)["']""")
                .find(manifest.readText())
                ?.groupValues
                ?.get(1)
                ?: return
        val setNs =
            androidExt.javaClass.methods.firstOrNull {
                it.name == "setNamespace" &&
                    it.parameterCount == 1 &&
                    it.parameterTypes[0] == String::class.java
            }
                ?: return
        setNs.invoke(androidExt, pkg)
    }

    fun org.gradle.api.Project.setAndroidLibraryCompileOptionsJava17() {
        if (!plugins.hasPlugin("com.android.library")) {
            return
        }
        val androidExt = extensions.findByName("android") ?: return
        val compileOptions =
            androidExt.javaClass.methods
                .firstOrNull { it.name == "getCompileOptions" && it.parameterCount == 0 }
                ?.invoke(androidExt)
                ?: return
        val coClass = compileOptions.javaClass
        fun invokeSetter(methodName: String, value: JavaVersion) {
            val methods = coClass.methods.filter { it.name == methodName && it.parameterCount == 1 }
            for (m in methods) {
                try {
                    m.invoke(compileOptions, value)
                    return
                } catch (_: Throwable) {
                    try {
                        m.invoke(compileOptions, value.toString())
                        return
                    } catch (_: Throwable) {
                        // try next overload
                    }
                }
            }
        }
        invokeSetter("setSourceCompatibility", JavaVersion.VERSION_17)
        invokeSetter("setTargetCompatibility", JavaVersion.VERSION_17)
    }

    fun org.gradle.api.Project.applyJvmAlignmentForOldPlugins() {
        setAndroidLibraryCompileOptionsJava17()
        tasks.withType(JavaCompile::class.java).configureEach {
            sourceCompatibility = JavaVersion.VERSION_17.toString()
            targetCompatibility = JavaVersion.VERSION_17.toString()
        }
        tasks.configureEach {
            if (!javaClass.name.contains("KotlinCompile")) {
                return@configureEach
            }
            try {
                val getKo =
                    javaClass.methods.firstOrNull { it.name == "getKotlinOptions" && it.parameterCount == 0 }
                        ?: return@configureEach
                val kotlinOptions = getKo.invoke(this) ?: return@configureEach
                val setJvm =
                    kotlinOptions.javaClass.methods.firstOrNull {
                        it.name == "setJvmTarget" &&
                            it.parameterCount == 1 &&
                            it.parameterTypes[0] == String::class.java
                    }
                        ?: return@configureEach
                setJvm.invoke(kotlinOptions, "17")
            } catch (_: Throwable) {
                // Ignore tasks that don't expose KotlinOptions the usual way.
            }
        }
    }

    fun org.gradle.api.Project.applyAndroidPluginWorkarounds() {
        applyLegacyLibraryNamespaceFromManifest()
        applyJvmAlignmentForOldPlugins()
    }

    // `evaluationDependsOn(":app")` can evaluate plugin projects before a plain `afterEvaluate` is registered.
    if (state.executed) {
        applyAndroidPluginWorkarounds()
    } else {
        afterEvaluate { applyAndroidPluginWorkarounds() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
