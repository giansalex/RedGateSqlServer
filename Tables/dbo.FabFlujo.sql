CREATE TABLE [dbo].[FabFlujo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (25) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabFlujo] ADD CONSTRAINT [PK_PrdFlujo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Flujo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabFlujo] ADD CONSTRAINT [FK_PrdFlujo_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
