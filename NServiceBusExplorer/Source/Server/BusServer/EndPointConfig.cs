namespace BusServer
{
    using NServiceBus;

    class EndPointConfig: IConfigureThisEndpoint, AsA_Publisher//, IWantCustomInitialization
    {
        #region IWantCustomInitialization Members

        /*void IWantCustomInitialization.Init()
        {
            NServiceBus.Configure.With()
                .DefaultBuilder()
                .DBSubcriptionStorage()
                .XmlSerializer();
        }
        */
        #endregion
    }
}
