import UserStatusMessage from "discourse/components/user-status-message";
import getURL from "discourse/lib/get-url";
import { applyValueTransformer } from "discourse/lib/transformer";

const CookedUserStatusMessage = <template>
  {{#in-element @data.wrapper}}
    <UserStatusMessage @status={{@data.status}} />
  {{/in-element}}
</template>;

export default function (element, context) {
  const {
    data: { post },
    state,
    owner,
    helper,
  } = context;

  state.extractedMentions = _extractMentions(element, post);

  const userStatusService = owner.lookup("service:user-status");

  const _updateUserStatus = (updatedUser) => {
    state.extractedMentions
      .filter(({ user }) => updatedUser.id === user?.id)
      .forEach(({ mentions, user }) => {
        _renderUserStatusOnMentions(mentions, user, helper);
      });
  };

  state.extractedMentions.forEach(({ mentions, user }) => {
    if (userStatusService.isEnabled) {
      user.statusManager?.trackStatus?.();
      user.on?.("status-changed", element, _updateUserStatus);

      _renderUserStatusOnMentions(mentions, user, helper);
    }

    const classes = applyValueTransformer("mentions-class", [], {
      user,
    });

    mentions.forEach((mention) => {
      mention.classList.add(...classes);
    });
  });

  // cleanup code
  return () => {
    state.extractedMentions = [];

    if (userStatusService.isEnabled) {
      post?.mentioned_users?.forEach((user) => {
        user.statusManager?.stopTrackingStatus?.();
        user.off?.("status-changed", element, _updateUserStatus);
      });
    }
  };
}

function _renderUserStatusOnMentions(mentions, user, helper) {
  mentions.forEach((mention) => {
    let wrapper = mention.querySelector(".user-status-message-wrapper");
    if (!wrapper) {
      wrapper = document.createElement("span");
      wrapper.classList.add("user-status-message-wrapper");
      mention.appendChild(wrapper);
    }

    helper.renderGlimmer(mention, CookedUserStatusMessage, {
      wrapper,
      status: user.status,
    });
  });
}

function _extractMentions(element, post) {
  return (
    post?.mentioned_users?.map((user) => {
      const href = getURL(`/u/${user.username.toLowerCase()}`);
      const mentions = element.querySelectorAll(`a.mention[href="${href}"]`);

      return { user, mentions };
    }) || []
  );
}
