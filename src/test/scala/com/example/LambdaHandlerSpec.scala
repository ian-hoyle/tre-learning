package com.example

import io.circe.generic.auto._
import io.circe.syntax._
import io.circe.{Decoder, Encoder}
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import uk.gov.nationalarchives.tre.messages.drisip.available.{DRIPreingestSipAvailable, FileType, Parameters}
import uk.gov.nationalarchives.tre.messages.event.{Producer, Properties}
import uk.gov.nationalarchives.common.messages.Status






class LambdaHandlerSpec extends AnyFlatSpec with Matchers {

  implicit val genderEncoder: Encoder[Producer.Value] = Encoder.encodeEnumeration(Producer)
  implicit val gftEncoder: Encoder[FileType.Value] = Encoder.encodeEnumeration(FileType)

  implicit val statusDecoder: Encoder[Status.Value] = Decoder.decodeEnumeration(Status)
  implicit val produceDecoder: Decoder[Producer.Value] = Decoder.decodeEnumeration(Producer)


  "handleRequest" should "do something interesting" in {

    val props = Properties(messageType = "uk.gov.nationalarchives.tre.messages.drisip.available.DRIPreingestSipAvailable", timestamp = "2023-03-29T11:00:12.280Z", producer = Producer.TRE,
      function = "tre-tf-module-drisip-create", executionId = "executionId344",
      parentExecutionId = None)


    val parameters = Parameters(sipBundleFileURI = "https://dev-tre-dpsg-out.s3.amazonaws.com/consignments/standard/TDR-2022-NQ3/9c6d25c1-c8c9-495a-be0b-91e7af7b2083/TDR-2022-NQ3/sip/MOCKA101Y22TBNQ3.tar.gz?X-Amz-Algorithm=AWS4-HMAC-...",
      sipBundleFileSha256URI = "https://dev-tre-dpsg-out.s3.amazonaws.com/consignments/standard/TDR-2022-NQ3/9c6d25c1...",
      fileType = FileType.GZ,
      series = "series name",
      batch = "batch identifier",
      transferringBody = "transferring body passed fro TDR",
      tdrRef = "tdr reference"
    )

    val judgmentPackageAvailable = DRIPreingestSipAvailable(props, parameters)
    val json = judgmentPackageAvailable.asJson.toString()
    println(json)


    1 shouldBe 1
  }
}
