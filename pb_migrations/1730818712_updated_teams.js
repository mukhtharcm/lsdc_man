/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7y03yrbjrzh7h1j")

  collection.listRule = "@request.auth.role = 'admin' || @request.auth.team = id || @request.auth.id ?= managers"
  collection.viewRule = "@request.auth.role = 'admin' || @request.auth.team = id || @request.auth.id ?= managers"
  collection.createRule = "@request.auth.role = 'admin'"
  collection.updateRule = "@request.auth.role = 'admin'"
  collection.deleteRule = "@request.auth.role = 'admin'"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7y03yrbjrzh7h1j")

  collection.listRule = null
  collection.viewRule = null
  collection.createRule = null
  collection.updateRule = null
  collection.deleteRule = null

  return dao.saveCollection(collection)
})
