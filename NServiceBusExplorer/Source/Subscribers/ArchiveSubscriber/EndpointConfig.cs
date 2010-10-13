namespace ArchiveSubscriber
{
    using NServiceBus;

    class EndpointConfig : IConfigureThisEndpoint, IWantCustomInitialization
    {
        #region IWantCustomInitialization Members

        void IWantCustomInitialization.Init()
        {
            NServiceBus.Configure.With()
                .DefaultBuilder()
                .XmlSerializer()
                .MsmqTransport()
                .IsTransactional(true)
                .UnicastBus()
                .DoNotAutoSubscribe()
                .LoadMessageHandlers();
        }

        #endregion
    }
}
