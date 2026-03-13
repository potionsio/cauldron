defmodule CauldronWeb.HomeLive do
  use CauldronWeb, :live_view

  @themes [
    %{
      body: "#7c3aed",
      body_dark: "#5b21b6",
      bubble: "rgba(167, 139, 250, 0.8)",
      glow: "rgba(139, 92, 246, 0.3)",
      accent: "#a78bfa",
      accent_dark: "#7c3aed"
    },
    %{
      body: "#059669",
      body_dark: "#047857",
      bubble: "rgba(110, 231, 183, 0.8)",
      glow: "rgba(16, 185, 129, 0.3)",
      accent: "#6ee7b7",
      accent_dark: "#059669"
    },
    %{
      body: "#d97706",
      body_dark: "#b45309",
      bubble: "rgba(252, 211, 77, 0.8)",
      glow: "rgba(245, 158, 11, 0.3)",
      accent: "#fcd34d",
      accent_dark: "#d97706"
    },
    %{
      body: "#0891b2",
      body_dark: "#0e7490",
      bubble: "rgba(103, 232, 249, 0.8)",
      glow: "rgba(6, 182, 212, 0.3)",
      accent: "#67e8f9",
      accent_dark: "#0891b2"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Home",
       app_name: app_name(),
       elixir_version: elixir_version(),
       otp_version: otp_version(),
       phoenix_version: phoenix_version(),
       db_status: db_status(socket),
       theme_index: 0,
       theme: Enum.at(@themes, 0)
     )}
  end

  defp app_name, do: Atom.to_string(:cauldron)

  defp elixir_version, do: System.version()

  defp otp_version, do: to_string(:erlang.system_info(:otp_release))

  defp phoenix_version, do: to_string(Application.spec(:phoenix, :vsn))

  defp db_status(socket) do
    if connected?(socket) do
      try do
        case Cauldron.Repo.query("SELECT 1") do
          {:ok, _} -> :connected
          _ -> :error
        end
      rescue
        _ -> :error
      end
    else
      :checking
    end
  end

  @impl true
  def handle_event("cycle_theme", _params, socket) do
    new_index = rem(socket.assigns.theme_index + 1, length(@themes))
    theme = Enum.at(@themes, new_index)
    {:noreply, assign(socket, theme_index: new_index, theme: theme)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="flex flex-col items-center justify-center min-h-screen py-16 space-y-12">
        <%!-- Hero Section --%>
        <section id="hero-section" class="flex flex-col items-center space-y-8">
          <%!-- Cauldron --%>
          <div
            id="cauldron"
            class="relative cursor-pointer select-none"
            phx-click="cycle_theme"
          >
            <%!-- Bubbles --%>
            <div class="absolute -top-16 left-1/2 -translate-x-1/2 w-32 h-36 overflow-hidden pointer-events-none">
              <div
                class="absolute bottom-0 left-3 rounded-full"
                style={"width: 8px; height: 8px; background: #{@theme.bubble}; animation: bubble-float 3s ease-in-out infinite; --drift: -8px;"}
              />
              <div
                class="absolute bottom-0 left-8 rounded-full"
                style={"width: 12px; height: 12px; background: #{@theme.bubble}; animation: bubble-float 2.5s ease-in-out infinite 0.5s; --drift: 12px;"}
              />
              <div
                class="absolute bottom-0 left-14 rounded-full"
                style={"width: 6px; height: 6px; background: #{@theme.bubble}; animation: bubble-float 3.5s ease-in-out infinite 1s; --drift: -5px;"}
              />
              <div
                class="absolute bottom-0 right-14 rounded-full"
                style={"width: 10px; height: 10px; background: #{@theme.bubble}; animation: bubble-float 2.8s ease-in-out infinite 0.3s; --drift: 6px;"}
              />
              <div
                class="absolute bottom-0 right-8 rounded-full"
                style={"width: 14px; height: 14px; background: #{@theme.bubble}; animation: bubble-float 3.2s ease-in-out infinite 0.8s; --drift: -10px;"}
              />
              <div
                class="absolute bottom-0 right-3 rounded-full"
                style={"width: 7px; height: 7px; background: #{@theme.bubble}; animation: bubble-float 2.6s ease-in-out infinite 1.2s; --drift: 4px;"}
              />
            </div>

            <%!-- Rim --%>
            <div
              class="relative z-10 w-32 h-4 rounded-t-lg mx-auto"
              style={"background: #{@theme.body};"}
            />

            <%!-- Body --%>
            <div
              class="relative z-10 w-28 h-24 rounded-b-full mx-auto"
              style={"background: linear-gradient(to bottom, #{@theme.body}, #{@theme.body_dark});"}
            />

            <%!-- Glow --%>
            <div
              class="absolute -bottom-4 left-1/2 -translate-x-1/2 w-36 h-12 rounded-full blur-xl"
              style={"background: #{@theme.glow}; animation: cauldron-glow 3s ease-in-out infinite;"}
            />
          </div>

          <%!-- Title --%>
          <div class="text-center space-y-3">
            <h1 class="text-4xl font-bold text-white tracking-tight sm:text-5xl">
              Your Potion is Brewing
            </h1>
            <p class="text-lg text-slate-400">
              Deployed with
              <a
                href="https://potions.io"
                class="font-semibold transition-colors duration-500"
                style={"color: #{@theme.accent};"}
              >
                Potions
              </a>
            </p>
          </div>
        </section>

        <%!-- Deploy Info Card --%>
        <section
          id="deploy-info"
          class="w-full max-w-md rounded-xl border border-slate-700/50 bg-slate-800/50 p-6"
        >
          <h2 class="text-sm font-semibold text-slate-300 uppercase tracking-wider mb-4">
            Deploy Info
          </h2>
          <dl class="grid grid-cols-2 gap-x-4 gap-y-3 text-sm">
            <dt class="text-slate-400">App</dt>
            <dd class="text-white font-medium">{@app_name}</dd>

            <dt class="text-slate-400">Elixir</dt>
            <dd class="text-white font-medium">{@elixir_version}</dd>

            <dt class="text-slate-400">OTP</dt>
            <dd class="text-white font-medium">{@otp_version}</dd>

            <dt class="text-slate-400">Phoenix</dt>
            <dd class="text-white font-medium">{@phoenix_version}</dd>

            <dt class="text-slate-400">Database</dt>
            <dd class="flex items-center gap-2">
              <%= cond do %>
                <% @db_status == :connected -> %>
                  <span class="w-2 h-2 rounded-full bg-green-400" />
                  <span class="text-green-400 font-medium">Connected</span>
                <% @db_status == :checking -> %>
                  <span class="w-2 h-2 rounded-full bg-slate-400 animate-pulse" />
                  <span class="text-slate-400 font-medium">Checking...</span>
                <% true -> %>
                  <span class="w-2 h-2 rounded-full bg-red-400" />
                  <span class="text-red-400 font-medium">Error</span>
              <% end %>
            </dd>
          </dl>
        </section>

        <%!-- Ingredients --%>
        <section id="ingredients" class="flex flex-wrap justify-center gap-3">
          <span class="inline-flex items-center rounded-full bg-slate-700 px-4 py-1.5 text-sm font-medium text-slate-200">
            Phoenix 1.8
          </span>
          <span class="inline-flex items-center rounded-full bg-slate-700 px-4 py-1.5 text-sm font-medium text-slate-200">
            LiveView
          </span>
          <span class="inline-flex items-center rounded-full bg-slate-700 px-4 py-1.5 text-sm font-medium text-slate-200">
            PostgreSQL
          </span>
          <span class="inline-flex items-center rounded-full bg-slate-700 px-4 py-1.5 text-sm font-medium text-slate-200">
            Tailwind CSS
          </span>
        </section>
      </div>
    </Layouts.app>
    """
  end
end
