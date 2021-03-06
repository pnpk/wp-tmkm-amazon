<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aws="http://webservices.amazon.com/AWSECommerceService/2006-06-28">

<xsl:output method="text" media-type="text/javascript" encoding="UTF-8"/>

<xsl:template match="/">
  cbSimilarityLookup({
  <xsl:apply-templates select="aws:SimilarityLookupResponse/aws:Items"/>
  });
</xsl:template>

<xsl:template match="aws:Items">
  "ItemId": "<xsl:value-of select="aws:Request/aws:SimilarityLookupRequest/aws:ItemId"/>",
  <xsl:choose>
    <xsl:when test="aws:Request/aws:Errors">
      "Error": 1,
      "ErrorCode": "<xsl:value-of select="aws:Request/aws:Errors/aws:Error/aws:Code"/>",
      "ErrorMessage": "<xsl:value-of select="aws:Request/aws:Errors/aws:Error/aws:Message"/>"
    </xsl:when>
    <xsl:otherwise>
      "Error": 0,
      "Items": [
      <xsl:apply-templates select="aws:Item"/>
      ]
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="aws:Item">
  {
  <xsl:apply-templates select="aws:ItemAttributes"/>
  <xsl:if test="aws:SmallImage">
    "SmallImage": {
      "URL": "<xsl:value-of select="aws:SmallImage/aws:URL"/>",
      "Width": <xsl:value-of select="aws:SmallImage/aws:Width"/>,
      "Height": <xsl:value-of select="aws:SmallImage/aws:Height"/>
    },
  </xsl:if>
  <xsl:if test="aws:MediumImage">
    "MediumImage": {
      "URL": "<xsl:value-of select="aws:MediumImage/aws:URL"/>",
      "Width": <xsl:value-of select="aws:MediumImage/aws:Width"/>,
      "Height": <xsl:value-of select="aws:MediumImage/aws:Height"/>
    },
  </xsl:if>
  <xsl:if test="aws:LargeImage">
    "LargeImage": {
      "URL": "<xsl:value-of select="aws:LargeImage/aws:URL"/>",
      "Width": <xsl:value-of select="aws:LargeImage/aws:Width"/>,
      "Height": <xsl:value-of select="aws:LargeImage/aws:Height"/>
    },
  </xsl:if>
  "URL": "<xsl:value-of select="aws:DetailPageURL"/>",
  "ASIN": "<xsl:value-of select="aws:ASIN"/>"
  <xsl:choose>
    <xsl:when test="position()=last()">}</xsl:when>
    <xsl:otherwise>},</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="aws:ItemAttributes">
  "Title": "<xsl:apply-templates select="aws:Title"/>",
  "Creator": "<xsl:for-each select="aws:Creator">
    <xsl:choose>
        <xsl:when test="position()=1"><xsl:apply-templates select="."/></xsl:when>
        <xsl:when test="position()=last()">、 <xsl:apply-templates select="."/></xsl:when>
        <xsl:otherwise>、 <xsl:apply-templates select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>",
</xsl:template>

<xsl:template match="aws:ItemAttributes/*">
  <xsl:call-template name="replace">
    <xsl:with-param name="str"><xsl:value-of select="."/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace">
  <xsl:param name="str"/>
  <xsl:param name="from">&#34;</xsl:param>
  <xsl:param name="to">\&#34;</xsl:param>
  <xsl:choose>
    <xsl:when test="contains($str, $from)">
      <xsl:value-of select="substring-before($str, $from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="replace">
        <xsl:with-param name="str" select="substring-after($str, $from)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
