namespace Messages.New
{
    using System;

    [Serializable]
    public class ProductUpdatedMessage : IProductUpdatedEvent
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

        public Int32 DepartmentNumber { get; set; }

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
