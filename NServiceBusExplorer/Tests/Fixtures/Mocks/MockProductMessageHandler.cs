namespace Fixtures.Mocks
{
    using NServiceBus;

    public class MockProductMessageHandler : IHandleMessages<ICommand>
    {
        public IBus Bus { get; set; }

        public void Handle(ICommand message)
        {
            // mock up a publish   
            this.Bus.Publish<IOrderAcceptedEvent>(
                m =>
                {
                    m.Id = message.CommandId;
                    m.Text = message.CommandText;
                }
            );
        }
    }
}
