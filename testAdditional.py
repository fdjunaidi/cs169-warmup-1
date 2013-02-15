"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib

import string # generate string 128 char
import random # generate string 128 char

class TestUnit(testLib.RestTestCase):
    """Issue a REST API request to run the unit tests, and analyze the result"""
    def testUnit(self):
        respData = self.makeRequest("/TESTAPI/unitTests", method="POST")
        self.assertTrue('output' in respData)
        print ("Unit tests output:\n"+
               "\n***** ".join(respData['output'].split("\n")))
        self.assertTrue('totalTests' in respData)
        print "***** Reported "+str(respData['totalTests'])+" unit tests"
        # When we test the actual project, we require at least 10 unit tests
        minimumTests = 10
        if "SAMPLE_APP" in os.environ:
            minimumTests = 4
        self.assertTrue(respData['totalTests'] >= minimumTests,
                        "at least "+str(minimumTests)+" unit tests. Found only "+str(respData['totalTests'])+". use SAMPLE_APP=1 if this is the sample app")
        self.assertEquals(0, respData['nrFailed'])


        
class TestAddUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAdd1(self):
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)

    def testAdd2(self):
        # Username too long
        long_term = ''.join(random.choice(string.lowercase) for x in range(130))
        password = "normal"
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : long_term, 'password' : password} )
        self.assertTrue(respData['errCode'] == -3)

    def testAdd3(self):
        # User already exists.
        username = "iamaduplicate"
        password = "iamaduplicate"
        self.makeRequest("/users/add", method="POST", data = { 'user' : username, 'password' : password} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : username, 'password' : password} )
        self.assertTrue(respData['errCode'] == -2)

    def testAdd4(self):
        # Password too long
        username = "normal"
        long_term = long_term = ''.join(random.choice(string.lowercase) for x in range(130))
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : username, 'password' : long_term} )
        self.assertTrue(respData['errCode'] == -4)

class TestLoginUser(testLib.RestTestCase):
    """Test logging in users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLogin1(self):
        # Good login credentials
        self.makeRequest("/users/add", method="POST", data = { 'user' : 'existuser', 'password' : 'existuser'} )
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'existuser', 'password' : 'existuser'} )
        self.assertTrue(respData['errCode']>0)

    def testLogin2(self):
        # Bad login credentials
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'randomnoexist', 'password' : 'randomnoexist'} )
        self.assertTrue(respData['errCode']==-1)


class TestUnitTests(testLib.RestTestCase):
    """Test Unit Tests"""
    def testReset(self):
        respData = self.makeRequest("/TESTAPI/unitTests", method="POST", data = {} )
        respData['output']
        self.assertTrue(respData['nrFailed']==0 and respData['totalTests']>10)

class TestResetFixture(testLib.RestTestCase):
    """Reseting database"""
    def testReset(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        self.assertTrue(respData['errCode']==1)