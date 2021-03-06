mysqlPool = require '../utils/mysqlPool'
mysql = require 'mysql'
dateformat = require 'dateformat'
config = require '../config'

class BaseModel
  constructor: (@table) ->

  query: (options, cb) ->
    {page} = options
    page = parseInt(page) or 0 if page
    sql = @getQuerySql?(options)
    unless sql
      sql = """
            SELECT
            *
            FROM #{mysql.escapeId @table.name}

            """
    if @table.orderBy
      sql += " ORDER BY #{@table.orderBy} "
    else
      sql += " ORDER BY #{mysql.escapeId @table.id} "
    sql += " LIMIT #{page * config.pageSize}, #{config.pageSize} " if page?
    mysqlPool.query sql, (err, rows) ->
      cb err, rows

  get: (id, cb) ->
    sql = """
          SELECT
          *
          FROM #{mysql.escapeId @table.name}
          WHERE #{mysql.escapeId @table.id} = #{mysql.escape id}
          """
    mysqlPool.query sql, (err, rows) ->
      return cb err if err
      return cb 'not found' unless rows and rows.length > 0
      cb err, rows[0]

  update: (id, item, cb) ->
    sql = """
          UPDATE #{mysql.escapeId @table.name}
          SET
          """
    fields = []
    for own field, type of @table.schema
      fields.push {field, type} if item[field]?
    for {field, type}, i in fields
      value = item[field]
      if type == Date
        value = dateformat item[field], 'yyyy-mm-dd HH:MM:ss'
      sql += " #{mysql.escapeId field} = #{mysql.escape value} "
      sql += " , " if i < (fields.length - 1)
    sql += " WHERE #{mysql.escapeId @table.id} = #{mysql.escape id} "
    mysqlPool.query sql, (err, result) ->
      cb err, result

  delete: (id, cb) ->
    sql = """
          DELETE
          FROM #{mysql.escapeId @table.name}
          WHERE #{mysql.escapeId @table.id} = #{mysql.escape id}
          """
    mysqlPool.query sql, (err, result) ->
      cb err, result

  create: (item, cb) ->
    sql = """
          INSERT
          INTO #{mysql.escapeId @table.name}
          SET
          """
    fields = []
    fields.push {field: @table.id, type: String} if item[@table.id]
    for own field, type of @table.schema
      fields.push {field, type} if item[field]?
    for {field, type}, i in fields
      value = item[field]
      if type == Date
        value = dateformat item[field], 'yyyy-mm-dd HH:MM:ss'
      sql += " #{mysql.escapeId field} = #{mysql.escape value} "
      sql += " , " if i < (fields.length - 1)
    mysqlPool.query sql, (err, result) ->
      cb err, result

module.exports = BaseModel