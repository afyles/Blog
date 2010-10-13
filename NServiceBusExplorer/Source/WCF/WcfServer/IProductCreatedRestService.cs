namespace WcfServer
{
    using System;
    using System.ServiceModel;
    using System.ServiceModel.Web;
    using System.ServiceModel.Activation;
    using NServiceBus;
    using Messages;

    [ServiceContract]
    public interface IProductCreatedRestService
    {
        [OperationContract]
        [WebInvoke(UriTemplate = "products", RequestFormat = WebMessageFormat.Xml, ResponseFormat = WebMessageFormat.Xml)]
        void Create(ProductCreatedMessage message);
    }

    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
    public class ProductCreatedRestService : IProductCreatedRestService
    {
        private readonly IBus bus;

        public ProductCreatedRestService()
        {
            if ( null == this.bus )
                this.bus = Configure.Instance.Builder.Build<IBus>();
        }

        public void Create(ProductCreatedMessage message)
        {
            this.bus.Send(message);
        }
    }

}
