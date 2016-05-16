fs = require('fs')
jsdom = require("jsdom").jsdom; 
$ = null

replaceScriptAndCssTagsByInliningInFile = (fileName, urlPrefix) ->
  fileContent = fs.readFileSync(fileName, 'utf-8')
  doc = jsdom(fileContent);
  window = doc.parentWindow;
  $ = require('jquery')(window)
  scriptMatches = findScriptTags(fileContent)
  cssMatches = findCssTags(fileContent)
  scriptMatchesToReplace =  filterScriptsByUrl(scriptMatches, urlPrefix)
  cssMatchesToReplace = filterCssFilesByUrl(cssMatches, urlPrefix)
  scriptReplacements = readInlineReplacementsForScripts(scriptMatchesToReplace)
  cssFileReplacements = readInlineReplacementsForCssFiles(cssMatchesToReplace)
  for own scriptTag, scriptFileContent of scriptReplacements
    fileContent = fileContent.replace(scriptTag, "<!--#{scriptTag}-->\n
    <script type='text/javascript'>\n
    #{scriptFileContent}\n
    </script>")
  for own cssFileTag, cssFileContent of cssFileReplacements
    fileContent = fileContent.replace(cssFileTag, "<!--#{cssFileTag}-->\n
    <style type='text/css'>\n
    #{cssFileContent}\n
    </style>")
  fs.writeFile(fileName.replace('.xml', '') + "-inlined.xml", fileContent, () ->
    console.log("written file")
  )

findCssTags = (xmlText) ->
  return xmlText.match(/<link.*rel *= *['"]stylesheet['"].*\/ *>/g)
  
findScriptTags = (xmlText) ->
  return xmlText.match(/<script src=([^>]*)((> *<\/script>)|\/ *>)/g)

filterScriptsByUrl = (scriptMatches, urlPrefix) ->
  return scriptMatches.filter((scriptMatch) -> $(scriptMatch).is("[src^='#{urlPrefix}']"))
  
filterCssFilesByUrl = (cssMatches, urlPrefix) ->
  return cssMatches.filter((cssMatch) -> $(cssMatch).is("[href^='#{urlPrefix}']"))

readInlineReplacementsForScripts = (scriptsToReplace) ->
    scriptsToReplacements = mapHTMLTagsToFileContents(scriptsToReplace, 'src')
    return scriptsToReplacements
  
readInlineReplacementsForCssFiles = (cssFilesToReplace) ->
    cssFileToReplacements = mapHTMLTagsToFileContents(cssFilesToReplace, 'href')
    return cssFileToReplacements

mapHTMLTagsToFileContents = (htmlTags, attribute) ->
  filesToContents = {}
  for htmlTag in htmlTags
    fileUrl = $(htmlTag).attr(attribute)
    # regex here depends on url... this one /\/rizzoma-gadget\/workspace\/(.*)/
    # is for preview c9users url style (may 2016)
    relativeFileName = fileUrl.match(/\/rizzoma-gadget\/workspace\/(.*)/)[1]
    fileContent = fs.readFileSync(relativeFileName, 'utf-8')
    filesToContents[htmlTag] = fileContent
  return filesToContents

exports.filterScriptsByUrl = filterScriptsByUrl
exports.findScriptTags = findScriptTags
exports.replaceScriptAndCssTagsByInliningInFile = replaceScriptAndCssTagsByInliningInFile