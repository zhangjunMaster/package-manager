mysqlPool = require '../utils/mysqlPool'
mysql = require 'mysql'
BaseModel = require './baseModel'
config = require '../config'

class Model extends BaseModel
  findOne: (options, cb) ->
    {username, password, roleid} = options
    sql = """
          SELECT
          *
          FROM #{mysql.escapeId @table.name} t1
          WHERE t1.name = #{mysql.escape username}
          AND t1.passwd = #{mysql.escape password}
          AND t1.roleid = #{mysql.escape roleid}

          """
    mysqlPool.query sql, (err, rows) ->
      return cb err if err
      return cb 'no such account' unless rows and rows.length > 0
      cb err, rows[0]

  query: (options, cb) ->
    sql = """
          select
          t1.id id,
          t1.name name,
          t1.memo memo,
          t1.realName realName
          from s_users t1
          where t1.roleid = #{mysql.escape config.salesRoleid}

          """
    mysqlPool.query sql, (err, rows) ->
      cb err, rows

module.exports = new Model
  name: 's_users'
  id: 'id'
  orderBy: 'id desc'
  schema:
    name: String
    passwd: String
    realName: String
    email: String
    phone: String
    qq: String
    roleid: Number

