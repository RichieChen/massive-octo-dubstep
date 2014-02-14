
import unittest
import sys
import testLib

class FunctionalTests(testLib.RestTestCase):
  def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.SUCCESS):
    expected = { 'errCode' : errCode }
    if count != 0:
      expected['count']  = count
    self.assertDictEqual(expected, respData)

  def testLogin1(self):
    #logging in nonexistent account
    respData = self.makeRequest("/users/login", method="POST", data = {'user' : 'user1', 'password' : 'abc' })
    self.assertResponse(respData, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS)

  def testLogin2(self):
    #logging w/ wrong password
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'user1', 'password' : 'abc'})
    self.assertResponse(respData, count = 1)
    respData = self.makeRequest("/users/login", method="POST", data = {'user' : 'user1', 'password' : '123' })
    self.assertResponse(respData, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS)

  def testAdd2(self):
    #username too long
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'useruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruseruser', 'password' : 'abc'})
    self.assertResponse(respData, errCode = testLib.RestTestCase.ERR_BAD_USERNAME)

  def testAdd3(self):
    #valid add w/ blank password
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'user2', 'password' : '' })
    self.assertResponse(respData, count = 1)
   
  def testAdd4(self):
    #username taken add
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'user3', 'password' : 'aaa'})
    self.assertResponse(respData, count = 1)
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'user3', 'password' : 'bbb'})
    self.assertResponse(respData, errCode = testLib.RestTestCase.ERR_USER_EXISTS)


  def testAdd5(self):
    #password too long
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'user4', 'password' : 'passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword'})
    self.assertResponse(respData, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD)

  def testLogin3(self):
    #counter works
    respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'user4', 'password' : 'qwer'})
    self.assertResponse(respData, count = 1)
    respData = self.makeRequest("/users/login", method="POST", data = {'user' : 'user4', 'password' : 'qwer'})
    self.assertResponse(respData, count = 2)