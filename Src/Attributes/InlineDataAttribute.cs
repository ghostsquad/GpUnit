﻿namespace PondUnit.Attributes {
    public class InlineDataAttribute : DataAttribute {
        #region Constructors and Destructors

        public InlineDataAttribute(params object[] values) {
            this.Values = values;
        }

        #endregion
    }
}