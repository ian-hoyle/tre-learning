import Dependencies._

ThisBuild / scalaVersion     := "2.13.5"
ThisBuild / version          := "0.1.0"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example.com"

lazy val root = (project in file("."))
  .settings(
    name := "lambda-container-scala-example",
    libraryDependencies ++= Seq(
      lambdaRuntimeInterfaceClient,
      scalaTest % Test,
      daTransformSchema,
      zioSqs,
      zioStreams
    )
  ).settings(
    assembly / assemblyOutputPath := file("target/function.jar")
  )
//libraryDependencies += "com.beachape" %% "enumeratum" % "1.5.13"
//libraryDependencies += "com.beachape" %% "enumeratum-circe" % "1.5.21"
libraryDependencies += "io.github.ian-hoyle" % "da-transform-schemas" % "0.102"


val circeVersion = "0.14.3"

libraryDependencies ++= Seq(
  "io.circe" % "circe-core",
  "io.circe" % "circe-generic",
  "io.circe" % "circe-parser",
  "io.circe" % "circe-generic-extras"
).map(_ % circeVersion)