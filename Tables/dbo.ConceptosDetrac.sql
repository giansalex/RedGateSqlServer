CREATE TABLE [dbo].[ConceptosDetrac]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CDtr] [char] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptosDetrac] ADD CONSTRAINT [PK_ConceptosDetrac] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CDtr]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptosDetrac] ADD CONSTRAINT [IX_ConceptosDetrac_RucE_Descrip] UNIQUE NONCLUSTERED  ([RucE], [Descrip]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptosDetrac] WITH NOCHECK ADD CONSTRAINT [FK_ConceptosDetrac_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[ConceptosDetrac] WITH NOCHECK ADD CONSTRAINT [FK_ConceptosDetrac_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0001', 'SCHEMA', N'dbo', 'TABLE', N'ConceptosDetrac', 'COLUMN', N'Cd_CDtr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001', 'SCHEMA', N'dbo', 'TABLE', N'ConceptosDetrac', 'COLUMN', N'Cd_Srv'
GO
