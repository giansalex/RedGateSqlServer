CREATE TABLE [dbo].[Campo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cp] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Oblig] [bit] NULL,
[IB_Exp] [bit] NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Campo] ADD CONSTRAINT [PK_Campo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cp]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Campo] WITH NOCHECK ADD CONSTRAINT [FK_Campo_CampoT] FOREIGN KEY ([Cd_TC]) REFERENCES [dbo].[CampoT] ([Cd_TC])
GO
ALTER TABLE [dbo].[Campo] WITH NOCHECK ADD CONSTRAINT [FK_Campo_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
