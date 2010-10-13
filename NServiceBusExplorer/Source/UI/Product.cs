namespace UI
{
    using System;
    using System.Messaging;
    using Messages;

    public partial class Product : System.Windows.Forms.Form
    {
        const string QueueName = @".\private$\NServiceBus_InBound";

        public Product()
        {
            InitializeComponent();
        }

        private static System.Messaging.MessageQueue GetQueue(string name)
        {
            System.Messaging.MessageQueue mq;

            if (MessageQueue.Exists(name))
                mq = new System.Messaging.MessageQueue(name);
            else
                mq = MessageQueue.Create(name);
            return mq;
        }

        private static void FireEvent(IProductChangedEvent eventMessage)
        {
            System.Messaging.MessageQueue mq = GetQueue(QueueName);
            mq.Formatter = new BinaryMessageFormatter();
            System.Messaging.Message mm = new System.Messaging.Message(eventMessage, new BinaryMessageFormatter());
            mm.Body = eventMessage;
            mq.Send(mm);
        }

        private void buttonSave_Click(object sender, EventArgs e)
        {

            Messages.New.IProductUpdatedEvent pu = new Messages.New.ProductUpdatedMessage
            {
                ProductNumber = int.Parse(textBoxUpdateID.Text),
                Description = textBoxUpdateDesc.Text,
                Name = textBoxUpdateName.Text,
                EventId = Guid.NewGuid(),
                Time = DateTime.Now,
                Duration = TimeSpan.FromSeconds(99999D),
                DepartmentNumber = 10
            };

            FireEvent(pu);
        }


        private void buttonDelete_Click(object sender, EventArgs e)
        {
            IProductRemovedEvent eventMessage = new ProductRemovedMessage
            {
                ProductNumber = int.Parse(textBoxDeleteId.Text),
                EventId = Guid.NewGuid(),
                Time = DateTime.Now,
                Duration = TimeSpan.FromSeconds(99999D)
            };

            FireEvent(eventMessage);
        }

        private void buttonInsert_Click(object sender, EventArgs e)
        {
            IProductCreatedEvent eventMessage = new ProductCreatedMessage
            {
                ProductNumber = int.Parse(textBoxInsertID.Text),
                Description = textBoxInsertDesc.Text,
                Name = textBoxInsertName.Text,
                EventId = Guid.NewGuid(),
                Time = DateTime.Now,
                Duration = TimeSpan.FromSeconds(99999D)
            };

            FireEvent(eventMessage);
        }
    }
}
