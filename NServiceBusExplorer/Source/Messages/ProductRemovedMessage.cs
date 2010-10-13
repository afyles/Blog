namespace Messages
{
    using System;

    [Serializable]
    public class ProductRemovedMessage : IProductRemovedEvent
    {
        #region IProductChangedEvent Members

        public int ProductNumber
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }

        public string Description
        {
            get;
            set;
        }

        #endregion

        #region IEvent Members

        public Guid EventId
        {
            get;
            set;
        }

        public DateTime Time
        {
            get;
            set;
        }

        public TimeSpan Duration
        {
            get;
            set;
        }

        #endregion
    }
}
