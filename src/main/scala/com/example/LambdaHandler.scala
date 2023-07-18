package com.example

import java.util.{ Map => JavaMap }
import com.amazonaws.lambda.thirdparty.com.google.gson.GsonBuilder
import com.amazonaws.services.lambda.runtime.{Context, RequestHandler}

class  LambdaHandler() extends RequestHandler[JavaMap[String, String], String] {
  val gson = new GsonBuilder().setPrettyPrinting.create

  override def handleRequest(event: JavaMap[String, String], context: Context): String = {
    val logger = context.getLogger

    logger.log(s"ENVIRONMENT VARIABLES: ")
    logger.log(s"CONTEXT: $context")

    logger.log(s"EVENT: $event")

    val returnMessage =
      """
        |{
        |  \"statusCode\": 200,
        |  \"body\": \"hello great one\"}
        |  """.stripMargin

    returnMessage

  }
}
