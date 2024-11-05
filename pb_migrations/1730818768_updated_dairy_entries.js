/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("35hutfa1k0lbavt")

  collection.listRule = "@request.auth.role = 'admin' || @request.auth.team = team || (@request.auth.role = 'teamManager' && @request.auth.team = team)"
  collection.viewRule = "@request.auth.role = 'admin' || @request.auth.team = team || (@request.auth.role = 'teamManager' && @request.auth.team = team)"
  collection.createRule = "@request.auth.role = 'admin' || @request.auth.role = 'teamManager'"
  collection.updateRule = "@request.auth.role = 'admin' || (@request.auth.role = 'teamManager' && @request.auth.team = team)"
  collection.deleteRule = " @request.auth.role = 'admin'"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("35hutfa1k0lbavt")

  collection.listRule = null
  collection.viewRule = null
  collection.createRule = null
  collection.updateRule = null
  collection.deleteRule = null

  return dao.saveCollection(collection)
})
