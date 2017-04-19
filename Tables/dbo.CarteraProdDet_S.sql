CREATE TABLE [dbo].[CarteraProdDet_S]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ct] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CarteraProdDet_S] WITH NOCHECK ADD CONSTRAINT [FK_CarteraProdDet_S_CarteraProd] FOREIGN KEY ([RucE], [Cd_Ct]) REFERENCES [dbo].[CarteraProd] ([RucE], [Cd_Ct])
GO
ALTER TABLE [dbo].[CarteraProdDet_S] WITH NOCHECK ADD CONSTRAINT [FK_CarteraProdDet_S_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Catalogo', 'SCHEMA', N'dbo', 'TABLE', N'CarteraProdDet_S', 'COLUMN', N'Cd_Ct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001', 'SCHEMA', N'dbo', 'TABLE', N'CarteraProdDet_S', 'COLUMN', N'Cd_Srv'
GO
