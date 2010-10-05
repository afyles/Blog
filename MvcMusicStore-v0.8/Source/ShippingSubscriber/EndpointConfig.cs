namespace ShippingSubscriber
{
    using NServiceBus;

    public class EndpointConfig : IConfigureThisEndpoint, AsA_Server
    {
        //public void Init()
        //{
        //    NServiceBus.Configure.With()
        //       .DefaultBuilder()
        //       .Sagas()
        //       .XmlSerializer()
        //       .MsmqTransport()
        //       .IsTransactional(true)
        //       .UnicastBus()
        //       .DoNotAutoSubscribe()
        //       .LoadMessageHandlers();
        //}
    }
}
