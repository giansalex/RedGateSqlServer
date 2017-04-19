CREATE TABLE [dbo].[CarteraProd]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ct] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CarteraProd] ADD CONSTRAINT [PK_Catalogo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Ct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CarteraProd] WITH NOCHECK ADD CONSTRAINT [FK_Catalogo_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Catalogo', 'SCHEMA', N'dbo', 'TABLE', N'CarteraProd', 'COLUMN', N'Cd_Ct'
GO
