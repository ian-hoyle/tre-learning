import sbt._

object Dependencies {
  lazy val lambdaRuntimeInterfaceClient = "com.amazonaws" % "aws-lambda-java-runtime-interface-client" % "2.3.1"
  lazy val scalaTest = "org.scalatest" %% "scalatest" % "3.2.15"
  lazy val daTransformSchema = "io.github.ian-hoyle" % "da-transform-schemas" % "0.107"
  //lazy val zioSns =  "io.github.vigoo" %% "zio-aws-sns" % "4.17.280.4"
  lazy val zioSqs = "io.github.vigoo" %% "zio-aws-sqs" % "4.17.280.4"
  lazy val zioSns =   "dev.zio" %% "zio-aws-sns" % "5.20.22.2"
  lazy val zioStreams = "dev.zio" %% "zio-streams" % "2.0.13"
}
