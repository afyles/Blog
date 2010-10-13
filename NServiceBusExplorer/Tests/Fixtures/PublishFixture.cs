namespace Fixtures
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus.Testing;
    using System;
    using Fixtures.Mocks;

    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class PublishFixture
    {
        public PublishFixture()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void EnsurePublishOccurred()
        {
            Test.Initialize();

            var id = Guid.NewGuid();
            var text = "HELLO WORLD";

            Test.Handler<MockProductMessageHandler>()
                .ExpectPublish<IOrderAcceptedEvent>(e => e.Id == id && e.Text.Equals(text))
                .OnMessage<ICommand>(c => { c.CommandText = text; c.CommandId = id; });
        }
    }
}
