namespace Messages
{
    using System;
    using System.Runtime.Serialization;

    [DataContract(Namespace = "")]
    public class ProductCreatedMessage : IProductCreatedEvent
    {
        #region IProductChangedEvent Members

        [DataMember]
        public int ProductNumber
        {
            get;
            set;
        }

        [DataMember]
        public string Name
        {
            get;
            set;
        }

        [DataMember]
        public string Description
        {
            get;
            set;
        }

        #endregion

        #region IEvent Members
        [DataMember]
        public Guid EventId
        {
            get;
            set;
        }

        [DataMember]
        public DateTime Time
        {
            get;
            set;
        }

        [DataMember]
        public TimeSpan Duration
        {
            get;
            set;
        }

        #endregion
    }
}
