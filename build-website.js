const fs = require('fs')

const linkTemplate = fs.readFileSync('./website/link.html.tpl').toString()
const indexTemplate = fs.readFileSync('./website/index.html.tpl').toString()
const content = require('./content.json')

const languages = ['en', 'ca', 'es']
const renderedItems = []
content.forEach((c) => {
  const multihash = c.multihash
  // TODO implement languages
  // languages.forEach((l) => {
  //   if (c.title[l] === undefined) {
  //     console.log(`Didn't have language ${l}`)
  //   } else {
  //     console.log(c.title[l])
  //   }
  // })
  const props = {
    date: c.added_at,
    title: c.title.en,
    linkHash: `https://dweb.cat${c.multihash}`,
    hash: c.multihash,
    linkSubdomain: `https://${c.subdomain}.dweb.cat/`,
    subdomain: c.subdomain
  }
  console.log(props)
  console.log()
  let newTpl = linkTemplate
  Object.keys(props).forEach((key) => {
    newTpl = newTpl.replace(`{{${key}}}`, props[key])
  })
  renderedItems.push(newTpl)
})
const renderedIndex = indexTemplate.replace('{{ITEMS}}', renderedItems.join(''))
fs.writeFileSync('./website/index.html', renderedIndex)
