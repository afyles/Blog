namespace WcfServer
{
    using NServiceBus;
    using System.ServiceModel.Web;

    public class RestServiceStartup : IWantToRunAtStartup
    {
        private WebServiceHost host;

        public void Run()
        {
            this.host = new WebServiceHost(typeof(ProductCreatedRestService));
            this.host.Open();
        }

        public void Stop()
        {
            if (null != this.host && this.host.State == System.ServiceModel.CommunicationState.Opened)
                this.host.Close();
        }
    }
}
