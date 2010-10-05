using NServiceBus;
using Messages;

namespace ShippingSubscriber
{
    public class ShippingEndpoint : IWantToRunAtStartup
    {
        public IBus Bus { get; set; }

        public void Run()
        {
            this.Bus.Subscribe<IOrderAcceptedEvent>();
        }

        public void Stop()
        {
            this.Bus.Unsubscribe<IOrderAcceptedEvent>();
        }
    }
}
